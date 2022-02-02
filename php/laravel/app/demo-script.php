<?php
require __DIR__.'/vendor/autoload.php';

// Run with DD_TRACE_CLI_ENABLED=true to trace the execution of this script
use DDTrace\SpanData;
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use Monolog\Formatter\JsonFormatter;

// create a log channel
$log = new Logger('demo-script');
$formatter = new JsonFormatter();
$handler = new StreamHandler('/data/logs/demo-script.log', Logger::DEBUG);
$handler->setFormatter($formatter);
$log->pushHandler($handler);

$log->pushProcessor(function ($record) {
    $context = \DDTrace\current_context();
    $record['dd'] = [
        'trace_id' => $context['trace_id'],
        'span_id'  => $context['span_id'],
    ];
    return $record;

});

function do_sleep($duration) {
    global $log;
    $log->warning('Attempting to use sleep in production. Please remove');
    sleep($duration);
    // Dot notation keys get expanded in Datadog. {"sleep": {"duration": 1}}
    $log->error('Used sleep in production', ['sleep.duration' => $duration]);
}

\DDTrace\trace_function(
    'do_sleep',
    function(SpanData $span, $args, $retval) {
        // Adds a custom span tag for trace search and analytics. Dot notation keys get expanded
        // in Datadog. {"sleep": {"duration": 1}}
        // https://docs.datadoghq.com/tracing/setup_overview/custom_instrumentation/php?tab=tracingfunctioncalls
        $span->meta['sleep.duration'] = $args[0] * 1000; // convert to ms
    }
);

$log->debug('sleeping 1 second');
do_sleep(1);

$log->info('Curling httpbin');
$ch = curl_init('https://httpbin.org/delay/1');
curl_exec($ch);

$log->debug('sleeping 1 second');
do_sleep(1);

?>

<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name', 'Laravel') }}</title>

    <!-- Fonts -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap">

    <!-- Styles -->
    <link rel="stylesheet" href="{{ asset('css/app.css') }}">

    <!-- Scripts -->
    <script
        src="https://www.datadoghq-browser-agent.com/datadog-rum-v4.js"
        type="text/javascript"
        crossorigin="anonymous">
    </script>
    <script>
        window.DD_RUM && window.DD_RUM.init({
            applicationId: "<appId>",
            clientToken: "<clientToken>",
            site: "datadoghq.com",
            // The name of the frontend as you want it to appear in when correlated with backend APM traces
            // e.g. laravel-frontend
            service: "<service>",
            env: "<env>", // The deployment environment. prod, stage, dev, local, etc
            // Specify a version number to identify the deployed version of your application in Datadog.
            // Just a string. Doesn't have to be semver
            version: "1.0.0",
            sampleRate: 100,
            trackInteractions: true,
            defaultPrivacyLevel: "mask-user-input",
            // This defines what URLs RUM will generate trace identifiers for when running HTTP calls to
            // external services and other APIs. If the service is also traced the traces will be merged
            // so you can see the whole picture in one flame graph and more accurately depict system dependencies.
            // https://docs.datadoghq.com/real_user_monitoring/connect_rum_and_traces?tab=browserrum
            allowedTracingOrigins: [
                /https?:\/\/localhost/,
                /https?:\/\/centrifugo:8001/,
                /https?:\/\/nginx/,
            ],
        });

        window.DD_RUM &&
        window.DD_RUM.startSessionReplayRecording();
    </script>
    <script src="{{ asset('js/app.js') }}" defer></script>
</head>

<body class="font-sans antialiased">
    <div class="min-h-screen bg-gray-100">
        @include('layouts.navigation')
        <!-- Page Content -->
        <main>
            {{ $slot }}
        </main>
    </div>
</body>

</html>

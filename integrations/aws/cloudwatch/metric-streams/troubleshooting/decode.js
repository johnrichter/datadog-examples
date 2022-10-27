// Compiled using these sources
// https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-formats-opentelemetry-parse.html
// https://repost.aws/questions/QU5ROxA0hrQFiWkRVG3YNN2Q/error-when-trying-to-parse-open-telemetry-0-7-0-data-from-metric-streams

const fs = require("fs");
const pb = require("google-protobuf");
const pbMetrics = require("./build/opentelemetry/proto/collector/metrics/v1/metrics_service_pb");

function parseRecord(data) {
  const result = [];

  // Loop until we've read all the data from the buffer
  while (data.length) {
    /* A Kinesis record can contain multiple `ExportMetricsServiceRequest`
           records, each of them starting with a header with an
           UnsignedVarInt32 indicating the record length in bytes:
            ------ --------------------------- ------ -----------------------
           |UINT32|ExportMetricsServiceRequest|UINT32|ExportMetricsService...
            ------ --------------------------- ------ -----------------------
         */
    const reader = new pb.BinaryReader(data);
    const messageLength = reader.decoder_.readUnsignedVarint32();
    const messageFrom = reader.decoder_.cursor_;
    const messageTo = messageFrom + messageLength;

    // Extract the current `ExportMetricsServiceRequest` message to parse
    const message = data.subarray(messageFrom, messageTo);

    // Parse the current message using the ProtoBuf library
    const parsed =
      pbMetrics.ExportMetricsServiceRequest.deserializeBinary(message);

    // Do whatever we want with the parsed message
    result.push(parsed.toObject());

    // Shrink the remaining buffer, removing the already parsed data
    data = data.subarray(messageTo);
  }

  return result;
}
fileSize = fs.statSync("path/to/messages/file").size;
fs.open("path/to/messages/file", "r", function (err, fd) {
  var buffer = Buffer.alloc(1);
  var data = new Uint8Array(fileSize);
  var n = 0;
  while (true) {
    var num = fs.readSync(fd, buffer, 0, 1, null);
    if (num === 0) break;
    data[n] = buffer[0];
    n += 1;
  }
  // parseRecord(data);
  console.log(JSON.stringify(parseRecord(data)));
});

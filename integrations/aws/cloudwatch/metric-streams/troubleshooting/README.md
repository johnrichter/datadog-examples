# Troubleshooting AWS Metric Streams

AWS Metric Streams to Datadog are encoded using the
[OpenTelemetry v0.7.0 binary (protobuf) spec](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-formats-opentelemetry.html).
This module will convert a batch of metric messages from OTEL protobufs to JSON. This is needed
because protobufs do not define how to delinate between messages in a group. A Kinesis record can
contain multiple `ExportMetricsServiceRequest` records, each of them starting with a header with an
`UnsignedVarInt32` indicating the record length in bytes:

```
+------+---------------------------+------+-----------------------
|UINT32|ExportMetricsServiceRequest|UINT32|ExportMetricsService...
+------+---------------------------+------+-----------------------
```

More on how to parse these messages can be found in the
[AWS Cloudwatch documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-metric-streams-formats-opentelemetry-parse.html).

More on how we do this with Python in Datadog can be found in [this blog post](https://www.datadoghq.com/blog/engineering/protobuf-parsing-in-python/).

This repo includes the [official OTEL-proto repo](https://github.com/open-telemetry/opentelemetry-proto)
as a git submodule.

## Prereqs

1. You'll need a file containing one or more of the OTEL-encoded messages from the Kinesis Data Stream.
   In my testing configured my stream to deliver to an S3 bucket and downloaded one of the objects that
   were uploaded to the bucket.
2. [Install the protobuf compiler](https://developers.google.com/protocol-buffers). For Mac this
   is `brew install protobuf`.
3. Build the OTEL protobufs for Javascript. More on this in the [Google Protobuf Docs](https://developers.google.com/protocol-buffers/docs/proto3#generating).

   ```bash
   mkdir -p build && \
   protoc --proto_path=./opentelemetry-proto --js_out=import_style=commonjs,binary:build \
       opentelemetry/proto/common/v1/common.proto \
       opentelemetry/proto/resource/v1/resource.proto \
       opentelemetry/proto/metrics/v1/metrics.proto \
       opentelemetry/proto/collector/metrics/v1/metrics_service.proto
   ```

   - If you run into the `protoc-gen-js: program not found or is not executable` error. The
     following will likely fix the problem. This is a current issue with Homebrew

     ```bash
     brew install protobuf@3
     brew link --overwrite protobuf@3
     ```

4. Install Node, Yarn, and Node dependencies. This project uses [Volta](https://volta.sh/) to manage
   Node and Yarn versions, but is not required. Check `package.json` for versions used while testing

   ```
   yarn install
   ```

## Decode

Open `decode.js` and replace `path/to/messages/file` with the path to the file containing the AWS
Cloudwatch OTEL-proto encoded messages you wish to view. Run it.

```bash
> node decode.js
[{"resourceMetricsList":[{"resource":{"attributesList":[{"key":"cloud.provider","value":{"stringValue":"aws","boolValue":false,"intValue":0,"doubleValue":0,"bytesValue":""}},{"key":"cloud.account.id","value":{"stringValue"
...
```

```bash
# Use jq to increase readability
> node decode.js | jq '.'
[
  {
    "resourceMetricsList": [
      {
        "resource": {
          "attributesList": [
            {
              "key": "cloud.provider",
              "value": {
                "stringValue": "aws",
                "boolValue": false,
                "intValue": 0,
                "doubleValue": 0,
                "bytesValue": ""
              }
            },
            {
              "key": "cloud.account.id",
              "value": {
...
```

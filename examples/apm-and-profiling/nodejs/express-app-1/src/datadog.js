const tracer = require("dd-trace");
tracer.init();
const logger = require("./logger");
// tracer.init({
//   experimental: {
//     // Excludes all traces with the top-level span with operation "express.request"
//     // Currently we aren't able to exclude by resource, e.g. GET /status, within
//     // the tracer configuration. We can do it within the http plugins
//     sampler: { rules: [{ sampleRate: 0, name: "express.request" }] },
//   },
// });
logger.info("before", { plugins: tracer._instrumenter._plugins.entries() });
tracer.use("http", {
  headers: ["x-kwri-client-id"],
  blocklist: ["/status"],
  service: process.env.DD_SERVICESSS,
});
tracer.use("http2", {
  headers: ["x-kwri-client-id"],
  blocklist: ["/status"],
});
logger.info("after", { plugins: tracer._instrumenter._plugins.entries() });
logger.info("env", process.env);
module.exports = tracer;

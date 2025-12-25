import http from "k6/http";
import { sleep } from "k6";

export const options = {
  vus: 50, // virtual users
  duration: "2m", // run for 2 minutes
};

export default function () {
  http.get("http://braintask-service.default.svc.cluster.local");
  sleep(0.2);
}

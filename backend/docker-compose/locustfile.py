# locustfile.py

from locust import HttpUser, task, between

class WebsiteUser(HttpUser):
    wait_time = between(1, 2)  # Wait time between tasks

    @task
    def frontend(self):
        self.client.get("/frontend")

    @task
    def backend(self):
        self.client.get("/backend")

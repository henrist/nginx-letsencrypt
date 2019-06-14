# Example usage

This directory is an example also used to test the setup.

The actual server at nginx-test.hsw.no is running haproxy and will
cause nginx-test.hsw.no:80 to be forwarded to dej872.hsw.no:8040
and nginx-test.hsw.no:443 to be forwarded to dej872.hsw.no:8041.
By setting up a reverse tunnel this can be used to run an integration test:

```bash
ssh \
  -R 0.0.0.0:8040:localhost:8040 \
  -R 0.0.0.0:8041:localhost:8041 \
  jump@dej872.hsw.no
```

Then test the setup by doing

```bash
docker-compose up --build
```

Both http://nginx-test.hsw.no and https://nginx-test.hsw.no should now
return response from the local running server.

# Example usage

This directory is an example also used to test the setup.

The nginx-test.hsw.no:80 is a reverse proxy to dej872.hsw.no:8040
and can be connected by reverse tunneling the port:

```bash
ssh -R 0.0.0.0:8040:localhost:8040 jump@dej872.hsw.no
```

Then test the setup by doing

```bash
docker-compose up --build
```

We cannot test the SSL cert because nginx-test.hsw.no:443 resolves
to the existing proxy server which will try to terminate the SSL for us,
but the setup allows us to check if we can request and renew certs.

import https from 'node:https';

const agent = new https.Agent({
  keepAlive: true,
  maxSockets: 50,
  maxFreeSockets: 10,
  timeout: 30_000,
});

function request(url, options = {}) {
  return new Promise((resolve, reject) => {
    const req = https.request(
      url,
      {
        ...options,
        agent,
      },
      (res) => {
        let body = '';

        res.setEncoding('utf8');

        res.on('data', chunk => {
          body += chunk;
        });

        res.on('end', () => {
          resolve({
            statusCode: res.statusCode,
            headers: res.headers,
            body,
          });
        });
      }
    );

    req.on('error', reject);
    req.end();
  });
}

const result = await request('https://example.com');

console.log(result.statusCode);
console.log(result.body);

const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});

const sub = redisClient.duplicate();
let dp = [1, 1];

function fib(index) {
  if (dp[index]) {
    return dp[index];
  }
  dp[index] = fib(index - 1) + fib(index - 2);
  return dp[index];
}

sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});

sub.subscribe('insert');



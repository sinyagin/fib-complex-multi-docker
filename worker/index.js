const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000,
});
const sub = redisClient.duplicate();

function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

function isNumeric(value) {
  return /^-?\d+$/.test(value);
}

sub.on('message', (channel, message) => {
  if (isNumeric(message)) {
    let fibValue = fib(parseInt(message));
    console.log(`I got ${message} Worker calculated ${fibValue}`)
    redisClient.hset('values', message, fibValue);
  }
  
});
sub.subscribe('insert');

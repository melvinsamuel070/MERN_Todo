module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "node-modules",
    },
    testenvironment: 'jest-Environment-jsdom', // Required for testing React components
  };
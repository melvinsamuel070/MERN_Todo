module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "node-modules",
    },
    testEnvironment: 'jest-environment-jsdom', // Required for testing React components
  };
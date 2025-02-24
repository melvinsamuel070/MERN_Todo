module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "node-modules",
    },
    testEnvironment: 'jest-environment-node', // Required for testing React components
  };
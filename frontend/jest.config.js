module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      
    },
    testEnvironment: 'jest-environment-node', // Required for testing React components
  };
module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "node-modules",
    },
    testenvironment: 'jest-environment-jsdom', // Required for testing React components
  };
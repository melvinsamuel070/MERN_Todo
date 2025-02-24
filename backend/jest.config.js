module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "node-modules",
    },
    testEnvironment: "jsdom", // Required for testing React components
  };
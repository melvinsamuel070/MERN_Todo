module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "jest-css-modules-transform",
    },
    testEnvironment: "jsdom", // Required for testing React components
  };
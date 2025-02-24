module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "jest-css-modules-transform",
    },
    testenvironment: 'jest-Environment-jsdom', // Required for testing React components
  };
module.exports = {
    transform: {
      "^.+\\.jsx?$": "babel-jest",
      "^.+\\.css$": "jest-css-modules-transform",
    },
    testenvironment: 'jest-environment-jsdom', // Required for testing React components
  };
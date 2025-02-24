module.exports = {
  transform: {
    "^.+\\.jsx?$": "babel-jest",
  },
  moduleNameMapper: {
    "\\.(css|less|scss|sass)$": "jest-transform-stub",
  },
  testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
};

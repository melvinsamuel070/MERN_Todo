// module.exports = {
//     transform: {
//       "^.+\\.jsx?$": "babel-jest",
//     },
//     moduleNameMapper: {
//       "\\.(css|less|scss|sass)$": "<rootDir>/src/__mocks__/styleMock.js",
//     },
//     testEnvironment: "jest-environment-jsdom",
//   };
  

module.exports = {
  transform: {
    "^.+\\.jsx?$": "babel-jest"
  },
  transformIgnorePatterns: [
    "/node_modules/(?!your-library-to-transform)/"
  ],
  testEnvironment: "jsdom"
};
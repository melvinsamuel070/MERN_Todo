// module.exports = {
//   transform: {
//     "^.+\\.jsx?$": "babel-jest",
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "jest-transform-stub",
//   },
//   testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
// };

module.exports = {
  transform: {
    "^.+\\.jsx?$": "babel-jest"
  },
  transformIgnorePatterns: [
    "/node_modules/(?!your-library-to-transform)/"
  ],
  testEnvironment: "jsdom"
};

// // jest.config.js
// module.exports = {
//   transform: {
//     '\\.(jpg|jpeg|png|gif|svg)$': 'jest-transform-stub'
//   }
// };

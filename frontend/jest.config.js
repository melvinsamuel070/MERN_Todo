// module.exports = {
//   transform: {
//     "^.+\\.jsx?$": "babel-jest",
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "jest-transform-stub",
//   },
//   testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
// };

// // jest.config.js
// module.exports = {
//   // ... other config options ...
//   moduleNameMapper: {
//     '\\.(css)$': 'identity-obj-proxy'
//   },
// };

// jest.config.js
module.exports = {
  transform: {
    '\\.(jpg|jpeg|png|gif|svg)$': 'jest-transform-stub'
  }
};

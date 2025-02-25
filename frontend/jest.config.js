// module.exports = {
//   transform: {
//     "^.+\\.jsx?$": "babel-jest",
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "jest-transform-stub",
//   },
//   testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
// };

// jest.config.js
module.exports = {
  // ... other config options ...
  moduleNameMapper: {
    '\\.(css)$': 'identity-obj-proxy'
  },
};

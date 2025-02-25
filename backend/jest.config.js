// module.exports = {
//     transform: {
//       "^.+\\.jsx?$": "babel-jest",
//     },
//     moduleNameMapper: {
//       "\\.(css|less|scss|sass)$": "<rootDir>/src/__mocks__/styleMock.js",
//     },
//     testEnvironment: "jest-environment-jsdom",
//   };
  

// jest.config.js
module.exports = {
  transform: {
    '\\.(jpg|jpeg|png|gif|svg)$': 'jest-transform-stub'
  }
};

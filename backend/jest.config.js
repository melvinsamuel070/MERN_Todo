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
  moduleNameMapper: {
    '\\.(css|less|scss|sass)$': '<rootDir>/__mocks__/styleMock.js',
  },
};
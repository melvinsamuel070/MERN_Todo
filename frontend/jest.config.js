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
  moduleNameMapper: {
    '\\.(css|less|scss|sass)$': '<rootDir>/__mocks__/styleMock.js',
    '\\.(jpg|jpeg|png|gif|webp|svg)$': '<rootDir>/__mocks__/fileMock.js',
  },
  testEnvironment: 'jsdom',
};
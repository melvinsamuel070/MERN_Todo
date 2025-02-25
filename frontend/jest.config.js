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
    '\\.(css|less|scss|sass)$': '<rootDir>/__mocks__/styleMock.js', // For CSS files
  },
  testEnvironment: 'jsdom',
};


// module.exports = {
//   moduleNameMapper: {
//     '^axios$': '<rootDir>/__mocks__/axios.js', // Map axios to your combined mock file
//     '\\.(css|less|scss|sass)$': '<rootDir>/__mocks__/axios.js', // Map CSS files to the same mock file
//   },
//   transform: {
//     '^.+\\.jsx?$': 'babel-jest',
//   },
//   testEnvironment: 'jsdom',
// };
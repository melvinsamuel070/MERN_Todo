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
  testEnvironment: 'jsdom',
  transform: {
    "^.+\\.jsx?$": "babel-jest"
  },
  setupFilesAfterEnv: ["@testing-library/jest-dom/extend-expect"]
};
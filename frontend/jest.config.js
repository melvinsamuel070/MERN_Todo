// module.exports = {
//   transform: {
//     "^.+\\.jsx?$": "babel-jest",
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "jest-transform-stub",
//   },
//   testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
// };

export default {
  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": "babel-jest"
  },
  moduleNameMapper: {
    "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",
    "\\.(svg|jpg|jpeg|png|gif|css|scss)$": "<rootDir>/__mocks__/fileMock.js"
  },
  testEnvironment: "jsdom",
};

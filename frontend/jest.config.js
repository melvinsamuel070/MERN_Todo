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
    "^.+\\.(js|jsx|ts|tsx)$": "babel-jest"  // Ensures Jest processes ES modules correctly
  },
  moduleNameMapper: {
    "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",
    "\\.(svg|jpg|jpeg|png|gif|css|scss)$": "<rootDir>/__mocks__/fileMock.js"
  },
  testEnvironment: "jsdom",
  extensionsToTreatAsEsm: [".jsx", ".js"],  // Treats JS files as ES modules
  globals: {
    "ts-jest": {
      useESM: true
    }
  }
};



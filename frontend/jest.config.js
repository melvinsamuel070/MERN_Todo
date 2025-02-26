// module.exports = {
//   transform: {
//     "^.+\\.jsx?$": "babel-jest",
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "jest-transform-stub",
//   },
//   testEnvironment: "jest-environment-jsdom",  // This ensures Jest uses JSDOM
// };

// module.exports = {
//   transform: {
//     "^.+\\.(js|jsx)$": "babel-jest"
//   },
//   moduleNameMapper: {
//     "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",
//     "\\.(svg|jpg|jpeg|png|gif)$": "<rootDir>/__mocks__/fileMock.js"
//   },
//   testEnvironment: "jsdom",
// };


module.exports = {
  moduleNameMapper: {
    ".*": "<rootDir>/__mocks__/styleMock.js"  // Redirect everything to an empty mock
  },
  testEnvironment: "jsdom",
};

// module.exports = {
//   moduleNameMapper: {
//     // Mock styles
//     "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",

//     // Mock image files
//     "\\.(jpg|jpeg|png|gif|webp|svg)$": "<rootDir>/__mocks__/fileMock.js",

//     // Mock all modules inside `frontend/__mocks__`
//     "^@/utils/(.*)$": "<rootDir>/__mocks__/styleMock.js",  
//     "^@/components/(.*)$": "<rootDir>/__mocks__/styleMock.js",
//     "^@/services/(.*)$": "<rootDir>/__mocks__/styleMock.js",

//     // Optional: Mock everything else (but be careful!)
//     // ".*": "<rootDir>/__mocks__/emptyMock.js",  // ❌ Can break Jest!
//   },
// };

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


// module.exports = {
//   moduleNameMapper: {
//     ".*": "<rootDir>/__mocks__/styleMock.js"  // Redirect everything to an empty mock
//   },
//   testEnvironment: "jsdom",
// };

module.exports = {
  moduleNameMapper: {
    "\\.(css|scss|sass|less)$": "<rootDir>/__mocks__/styleMock.js", // Mock CSS files
    "\\.(png|jpg|jpeg|gif|svg)$": "<rootDir>/__mocks__/fileMock.js", // Mock images
  },
  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": "babel-jest", // Ensure JavaScript files are transformed properly
  },
  testEnvironment: "jsdom",
  transformIgnorePatterns: ["/node_modules/(?!axios)/"], // Allow axios to be transformed
};

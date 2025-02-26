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
  testEnvironment: "jsdom",  // ✅ Ensures Jest handles React properly
  passWithNoTests: true,     // ✅ Bypasses "No tests found" error

  moduleNameMapper: {
    // ✅ Mock styles (CSS, SCSS, LESS)
    "\\.(css|less|scss|sass)$": "<rootDir>/__mocks__/styleMock.js",

    // ✅ Mock images (JPG, PNG, SVG)
    "\\.(jpg|jpeg|png|gif|webp|svg)$": "<rootDir>/__mocks__/fileMock.js"
  },

  transform: {
    "^.+\\.(js|jsx|ts|tsx)$": "babel-jest" // ✅ Transpile JavaScript using Babel
  },

  transformIgnorePatterns: ["/node_modules/"], // ✅ Avoid issues with dependencies

  testPathIgnorePatterns: ["/node_modules/", "/dist/"], // ✅ Ignore unnecessary paths
};

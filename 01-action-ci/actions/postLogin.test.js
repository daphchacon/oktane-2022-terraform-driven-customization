import { onExecutePostLogin } from "./postLogin";
import { isLoginValid, restrictedAppName } from "./utilities";

const invalidEvent = {
  client: {
    name: restrictedAppName
  }
};

const validEvent = {
  client: {
    name: `not_${restrictedAppName}`
  }
}

describe("isLoginValid", () => {
  describe("Invalid Login", () => {
    test('Restricted App', () => {
      expect(isLoginValid(invalidEvent)).toBe(false);
    });
  });
  describe("Valid Login", () => {
    test('Unrestricted App', () => {
      expect(isLoginValid(validEvent)).toBe(true);
    });
  });
});

describe("onExecutePostLogin", () => {
  describe("Invalid Login", () => {
    test('Login Should Deny', async () => {
      const denyMock = jest.fn();
      const api = {
        access: {
          deny: denyMock
        }
      };
      await onExecutePostLogin(invalidEvent, api);
      expect(denyMock.mock.calls.length).toBe(1);
    });
  });

  describe("Valid Login", () => {
    test('Login Should Continue', async () => {
      const denyMock = jest.fn()
      const api = {
        access: {
          deny: denyMock
        }
      }
      await onExecutePostLogin(validEvent, api);
      expect(denyMock.mock.calls.length).toBe(0);
    });
  });
});

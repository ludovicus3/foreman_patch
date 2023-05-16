
export const getResponseErrorMsgs = ({ data, actionType } = {}) => {
  if (data) {
    const messages = data.displayMessage || data.message || data.errors || data.error?.message;
    return Array.isArray(messages) ? messages : [messages];
  }
  return [];
}

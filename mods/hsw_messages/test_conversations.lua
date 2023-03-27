local messages = assert(hsw.messages)

messages:register_conversation("hsw:test_conversation", {
  subject = "Test Conversation",
  from = "Test Thing",
  messages = {
    {
      body = "Test Body #1",
    },
    {
      body = "Test Body #2",
    },
    {
      body = "Test Body #3",
    },
    {
      body = "Test Body #4",
    },
  }
})

messages:register_conversation("hsw:test_conversation_2", {
  subject = "Test Conversation 2",
  from = "Test Thing",
  messages = {
    {
      body = "Test Body #1",
    },
    {
      body = "Test Body #2",
    },
    {
      body = "Test Body #3",
    },
    {
      body = "Test Body #4",
    },
  }
})

messages:register_conversation("hsw:test_conversation_3", {
  subject = "Test Conversation 3",
  from = "Test Thing",
  messages = {
    {
      body = "Test Body #1",
    },
    {
      body = "Test Body #2",
    },
    {
      body = "Test Body #3",
    },
    {
      body = "Test Body #4",
    },
  }
})

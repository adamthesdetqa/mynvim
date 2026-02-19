return {{
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {{
        "nvim-lua/plenary.nvim",
        branch = "master"
    }},
    build = "make tiktoken",
    opts = {
        -- See Configuration section for options
    },
    keys = {{
        "<leader>cc",
        ":CopilotChatToggle<CR>",
        desc = "Toggle Copilot Chat",
        mode = "n"
    }, {
        "<leader>cc",
        ":CopilotChat<CR>",
        desc = "Toggle Copilot Chat",
        mode = "v"
    }, {
        "<leader>cd",
        "<cmd>CopilotChatDocs<CR>",
        desc = "CopilotChat Docs",
        mode = "v"
    }, {
        "<leader>cf",
        "<cmd>CopilotChatFix<CR>",
        desc = "CopilotChat Fix",
        mode = "v"
    }, {
        "<leader>ce",
        ":CopilotChatExplain<CR>",
        desc = "CopilotChat: Explain",
        mode = "v"
    }, {
        "<leader>cr",
        ":CopilotChatReview<CR>",
        desc = "CopilotChat: Review",
        mode = "v"
    }, {
        "<leader>cR",
        ":CopilotChatReviewAll<CR>",
        desc = "CopilotChat: Review All",
        mode = "v"
    }, {
        "<leader>cC",
        ":CopilotChatClear<CR>",
        desc = "CopilotChat: Clear",
        mode = "v"
    }, {
        "<leader>cS",
        ":CopilotChatSave<CR>",
        desc = "CopilotChat: Save",
        mode = "v"
    }, {
        "<leader>cA",
        ":CopilotChatAdd<CR>",
        desc = "CopilotChat: Add",
        mode = "v"
    }}
}}

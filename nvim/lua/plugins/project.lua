return {
  {
    "ahmedkhalf/project.nvim",
    opts = {
      patterns = {
        ".git",
        "package.json",
        "Makefile",
        "CMakeLists.txt",
        ".nvim",   -- <-- ADD THIS LINE
        -- you can add more markers if needed, e.g., ".project"
      },
    },
  },
}

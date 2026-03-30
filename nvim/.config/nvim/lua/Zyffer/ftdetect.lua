return {
  vim.filetype.add({
    filename = {
      [".zshrc"] = "sh",
      [".zprofile"] = "sh",
      [".zshenv"] = "sh",
      [".zlogin"] = "sh",
      [".zlogout"] = "sh",
    },
    extension = {
      zsh = "sh",
      sh = "sh",
      bash = "sh",
    },
  })
}

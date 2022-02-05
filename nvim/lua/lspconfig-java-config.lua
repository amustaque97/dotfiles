local config = {
    -- This is required because for some reason java lsp is trying to attach itself
    -- to non java files. This is an attempt to fix issue.
    -- UPDATE: adding a filetypes attribute works! ^_^
    filetypes = { 'java' },
    cmd = {
        'java',
    	'-Declipse.application=org.eclipse.jdt.ls.core.id1',
    	'-Dosgi.bundles.defaultStartLevel=4',
    	'-Declipse.product=org.eclipse.jdt.ls.core.product',
    	'-Dlog.level=ALL',
    	'-noverify',
    	'-Xmx1G',
    	'-jar', '/Users/mustaque/.config/nvim/others/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar',
    	'-configuration', '/Users/mustaque/.config/nvim/others/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_mac',
    	'-data', '/Users/mustaque/java_workspace',
    	'--add-modules=ALL-SYSTEM',
    	'--add-opens java.base/java.util=ALL-UNNAMED',
    	'--add-opens java.base/java.lang=ALL-UNNAMED',
    },
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),

    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
      }
    },

    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = {}
    },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

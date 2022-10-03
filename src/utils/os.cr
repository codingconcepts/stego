module Utils
    def put_exit(msg : String, code : Int = 1)
        puts msg
        exit code
    end
end
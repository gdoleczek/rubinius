shared :file_unlink do |cmd|
  describe "File.#{cmd}" do
    before :each do
      @file1 = 'test.txt'
      @file2 = 'test2.txt'
      File.send(cmd, @file1) if File.exists?(@file1)
      File.send(cmd, @file2) if File.exists?(@file2)

      File.open(@file1, "w") {} # Touch
      File.open(@file2, "w") {} # Touch
    end

    after :each do
      File.send(cmd, @file1) if File.exists?(@file1)
      File.send(cmd, @file2) if File.exists?(@file2)

      @file1 = nil
      @file2 = nil
    end

    it "returns 0 when called without arguments" do
      File.send(cmd).should == 0
    end

    it "deletes a single file" do
      File.send(cmd, @file1).should == 1
      File.exists?(@file1).should == false
    end

    it "deletes multiple files" do
      File.send(cmd, @file1, @file2).should == 2
      File.exists?(@file1).should == false
      File.exists?(@file2).should == false
    end

    it "raises an TypeError if not passed a String type" do
      lambda { File.send(cmd, 1) }.should raise_error(TypeError)
    end
    
    it "raises an Errno::ENOENT when the given file doesn't exist" do
      lambda { File.send(cmd, 'bogus') }.should raise_error(Errno::ENOENT)
    end

    it "coerces a given parameter into a string if possible" do
      class Coercable
        def to_str
          "test.txt"
        end
      end

      File.send(cmd, Coercable.new).should == 1
    end
  end
end

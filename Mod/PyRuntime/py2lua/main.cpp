#include <boost/process.hpp>
#include <iostream>

using namespace boost::process;

int main()
{
    ipstream out;
    opstream in;

    child c("cat", std_in < in, std_out > out);

    std::string path = "echo content";
    in.write(path.c_str(), path.length());
    in.flush();
    in.pipe().close();
    
    std::string line;
    while (std::getline(out, line)) 
       std::cout << line << std::endl;

    c.wait();
    
    int res = c.exit_code();
    std::cout << res;
}

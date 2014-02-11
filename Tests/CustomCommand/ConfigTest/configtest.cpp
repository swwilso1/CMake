#include <string>
#include "configtest.h"

extern std::string theConfigurationName(void);

int main()
{
  if(theConfigurationName() != CONFIGURATION)
    return -1;
  return 0;
}

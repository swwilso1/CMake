#if defined(WIN32) || defined(__CYGWIN__)
# define DLLEXPORT __declspec(dllexport)
#else
# define DLLEXPORT
#endif

DLLEXPORT void doNothing1(void)
{
  return;
}

DLLEXPORT void doNothing2(void)
{
  return;
}

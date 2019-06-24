# Why are there tests here

Yup. There tests in lib.

The purpose of the `contracts` directory is to ensure that the implementation of our in memory repositories and our database-backed repos stay in sync. The tests are written in such a way that they allow you to pass in a repository, as long as it responds to the methods that the test uses.

Basically this is the directory that ensures repos in persistence act the way that use cases in `core` expect them to be acting. This is especially important since we run our tests against `use_cases` using fake repositories (in `spec/test_support`).

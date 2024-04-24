using Test, Aqua, LibAwsAuth, LibAwsCommon

@testset "LibAwsAuth" begin
    @testset "aqua" begin
        Aqua.test_all(LibAwsAuth, ambiguities=false)
        Aqua.test_ambiguities(LibAwsAuth)
    end
    @testset "basic usage to test the library loads" begin
        alloc = aws_default_allocator() # important! this shouldn't need to be qualified! if we generate a definition for it in LibAwsAuth that is a bug.
        aws_auth_library_init(alloc)
    end
end

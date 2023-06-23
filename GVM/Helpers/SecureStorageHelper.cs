
public static class SecureStorageHelper
{
    private const string ConnectionStringKey = "GVMConnectionString";
    private const string ConnectionString = "Server=gvm.database.windows.net;Initial Catalog=GVM;Persist Security Info=False;User ID=gvm_program;Password=i6Fu&#5QDEThgM;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";

    public static async Task SaveConnectionStringAsync()
    {
        await SecureStorage.SetAsync(ConnectionStringKey, ConnectionString);
    }

    public static async Task<string> GetConnectionStringAsync()
    {
        return await SecureStorage.GetAsync(ConnectionStringKey);
    }
}
using Dapper;
using Npgsql;
using System.Data;

namespace UserApi.Repositories;

public class UserRepository : IUserRepository
{
    private readonly IConfiguration _configuration;

    public UserRepository(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task CreateUserAsync(
        string nombre,
        string telefono,
        string direccion,
        int paisId,
        int departamentoId,
        int municipioId
    )
    {
        using var connection = new NpgsqlConnection(
            _configuration.GetConnectionString("DefaultConnection")
        );

        var parameters = new DynamicParameters();
        parameters.Add("p_nombre", nombre);
        parameters.Add("p_telefono", telefono);
        parameters.Add("p_direccion", direccion);
        parameters.Add("p_pais_id", paisId);
        parameters.Add("p_departamento_id", departamentoId);
        parameters.Add("p_municipio_id", municipioId);

        await connection.ExecuteAsync(
            "sp_insert_usuario",
            parameters,
            commandType: CommandType.StoredProcedure
        );
    }
}

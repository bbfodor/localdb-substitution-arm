# LocalDB Substitution ARM

A LocalDB substitution for ARM chipsets.
Allows the usage of `.mdf` and `.ldf` files as database in a containerized Azure SQL Edge server.

## Dependencies

- docker (https://www.docker.com/)
- sqlcmd (https://github.com/microsoft/go-sqlcmd)

## Usage

1. Make sure you have the required dependencies
2. In a project that contains your database files, clone this repo to a subfolder (ex. `/sh`)
3. Run the scripts in order

You can modify the `.env` file and/or any script as needed.

## Examples

### C# w/ Entity Framework

```csharp
using Microsoft.EntityFrameworkCore;

public class CustomDbContext : DbContext
    {
        public DbSet<CustomData> Data { get; set; }

        public CustomDbContext()
        {
            Database.EnsureCreated();
        }

        protected override void OnConfiguring(DbContextOptionsBuilder builder)
        {
            // NOTE: could read from .env
            builder.UseSqlServer("Server=localhost,1431;Database=defaultdb;User Id=sa;Password=SomePassword@01;");

            // This would be the LocalDB data source, which does not work on ARM.
            // builder.UseSqlServer(@"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\DB.mdf;Integrated Security=True");
        }
    }
```

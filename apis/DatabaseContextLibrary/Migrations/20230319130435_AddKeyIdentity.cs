using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DatabaseContextLibrary.Migrations
{
    /// <inheritdoc />
    public partial class AddKeyIdentity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<Guid>(
                name: "Id",
                table: "Announcements",
                defaultValueSql: "newsequentialid()");

            migrationBuilder.AlterColumn<Guid>(
                name: "Id",
                table: "Pets",
                defaultValueSql: "newsequentialid()");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<Guid>(
                name: "Id",
                table: "Announcements",
                defaultValueSql: string.Empty);

            migrationBuilder.AlterColumn<Guid>(
                name: "Id",
                table: "Pets",
                defaultValueSql: string.Empty);
        }
    }
}

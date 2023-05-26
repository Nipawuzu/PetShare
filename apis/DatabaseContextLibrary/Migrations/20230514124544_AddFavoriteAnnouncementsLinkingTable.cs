using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DatabaseContextLibrary.Migrations
{
    /// <inheritdoc />
    public partial class AddFavoriteAnnouncementsLinkingTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "AdopterLikedAnnouncementsLinkingTables",
                columns: table => new
                {
                    AdopterId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    AnnouncementId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_AdopterLikedAnnouncementsLinkingTables", x => new { x.AdopterId, x.AnnouncementId });
                    table.ForeignKey(
                        name: "FK_AdopterLikedAnnouncementsLinkingTables_Adopters_AdopterId",
                        column: x => x.AdopterId,
                        principalTable: "Adopters",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_AdopterLikedAnnouncementsLinkingTables_Announcements_AnnouncementId",
                        column: x => x.AnnouncementId,
                        principalTable: "Announcements",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_AdopterLikedAnnouncementsLinkingTables_AnnouncementId",
                table: "AdopterLikedAnnouncementsLinkingTables",
                column: "AnnouncementId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "AdopterLikedAnnouncementsLinkingTables");
        }
    }
}

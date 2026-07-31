<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;

/**
 * Creates the three CMS roles referenced by User::canAccessPanel() and
 * described in docs/architecture/system-architecture.md. Fine-grained
 * per-action permissions (e.g. scholar_reviewer can approve but not
 * delete) are future work — for the Foundation Package's CMS, any of
 * these three roles grants full access to the admin panel.
 */
class RoleSeeder extends Seeder
{
    public function run(): void
    {
        foreach (['admin', 'scholar_reviewer', 'content_editor'] as $role) {
            Role::findOrCreate($role, 'web');
        }
    }
}
